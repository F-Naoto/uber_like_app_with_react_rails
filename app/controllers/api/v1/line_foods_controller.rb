module Api
  module v1
    class LineFoodsControllers < ApplicationController
    before_action :set_food, only:%i[create replace]

    def index
      # 仮注文のデータがあった場合、
      # そのidsと最初の店舗情報とその合計数と合計金額をjsonで返す

      line_foods = LineFood.active
      if line_foods.exist?
        render json:{
          line_food_ids:line_foods.map {|line_food| line_food.id},
          restaurant:line_foods[0].restaurant,
          # [1, 2, 3].sum
          # (1..10).sum {|v| v * 2 }  => 110
          # つまり、配列の数を数えている？冗長な気が...
          count: line_foods.sum {|line_food| line_food[:count]},
          amount: line_foods.sum { |line_food| line_food.total_amount },
          }, status: :ok
      else
        render json: {}, status: :no_content
      end
    end

    # scope :active, -> { where(active: true)}
    # scope :other_restaurant, -> (picked_restaurant_id) { where.not(restaurant_id: picked_restaurant_id) }
    def create
      # 仮注文がavtiveなレコードを検索
      # その中で、仮注文中の店舗でないレコードが存在していたら
      # これって本来はユーザーのidも必要？
      if LineFood.active.other_restaurant(@ordered_food.restaurant.id).exist
        return render json:{
          existing_restaurant: LineFood.other_restaurant(@ordered_food.restaurant.id).first.restaurant.name,
          new_restaurant: Food.find(params[:food_id]).restaurant.name,
        }, status: :not_acceptable
      end

      set_line_food(@ordered_food)

      if @line_food.save
        render json: {
          line_food: @line_food
        }, status: :created
      else
          render json: {}, status: :internal_server_error
      end
    end

    def replace
      #注文中のデータから、見ている画面に該当しない店舗を検索する=>全てnot_active状態に更新する
      LineFood.active.other_restaurant(@ordered_food.restaurant.id).each do |line_food|
        line_food.update_attribute(:active, false)
      end

      set_line_food(@ordered_food)

      if @line_food.save
        render json: {
          line_food: @line_food
        }, status: :created
      else
        render json: {}, status: :internal_server_error
      end
    end

    private
      def set_food
        @ordered_food = Food.find(params[:food_id])
      end

      def set_line_food(ordered_food)
        if ordered_food.line_food.present?
          @line_food = ordered_food.line_food
          @line_food.attributes = {
            count: ordered_food.line_food.count + params[:count],
            active: true
          }
        else
          @line_food = ordered_food.build_line_food(
            count: params[:count],
            restaurant: ordered_food.restaurant,
            active: true
          )
        end
      end
    end
  end
end
