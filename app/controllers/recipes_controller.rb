class RecipesController < ApplicationController 
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response


    def index 
        user = User.find_by(id: session[:user_id])
        recipe = Recipe.all
        if user 
        render json: recipe, status: :created
        else  
        render json: {errors: ["Unauthorized"]}, status: :unauthorized 
        end 
    end

    def create 
        user = User.find_by(id: session[:user_id])
        if user
            recipe = user.recipes.create!(recipe_params) 
            render json: recipe, status: :created 
        else  
            render json: {errors: ["Unauthorized"]}, status: :unauthorized 
        end
    end

    private 
def recipe_params 
    params.permit(:title, :instructions, :minutes_to_complete)
end 

def render_unprocessable_entity_response(exception)
    render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity
  end

end
