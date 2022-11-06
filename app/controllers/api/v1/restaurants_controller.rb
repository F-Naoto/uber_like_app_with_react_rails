#moduleは名前空間を指定している
# restaurants_controller.rbはapi/v1/ディレクトリにあるため、module ApiとV1が記述される
module Api
  module V1
    class RestaurantsController < ApplicationController
      def index
        restaurants = Restaurant.all

        render json: {
          restaurants: restaurants
        }, status: :ok
      end
    end
  end
end
