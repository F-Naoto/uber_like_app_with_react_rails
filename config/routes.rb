Rails.application.routes.draw do
  namespace :api do
    # アプリケーションの開発途中でAPIの仕様を大きく変更する必要がでる場合に備えてURL自体にバージョン番号を持たせる
    namespace :v1 do
      resources :restaurants do
        resources :foods, only: %i[index]
      end
      resources :line_foods, only: %i[index create]
      put 'line_foods/replace', to: 'line_foods#replace'
      resources :orders, only: %i[create]
    end
  end
end
