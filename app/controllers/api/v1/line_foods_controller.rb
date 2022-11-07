module Api
  module v1
    class LineFoodsControllers < ApplicationController
      before_action :set_food, only:%i[create]

      # scope :active, -> { where(active: true)}
      # scope :other_restaurant, -> (picked_restaurant_id) { where.not(restaurant_id: picked_restaurant_id) }
      def create
        # 仮注文がavtiveなレコードを検索
        # その中で、仮注文中の店舗でないレコードが存在していたら
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
