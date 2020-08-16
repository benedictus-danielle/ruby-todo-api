module Api
    class TodosController < ApplicationController
        before_action :authenticate_request!
        def index
            user = JWT.decode(request.headers['Authorization'].split(' ').last, Rails.application.secrets.secret_key_base)[0]

            todos = Todo.where("user_id = ?",user["user_id"]).order('created_at DESC')
            render json: {status: 'success', message: 'Todos loaded', data: todos}, status: :ok
        end
        
        def show
            todo = Todo.find(params[:id])
            render json: {status: 'success', message: 'Todo loaded', data: todo}, status: :ok
        end

        def create
            todo = Todo.new(todo_params)
            if todo.save
                render json: {status: 'success', message: 'Todo inserted', data: todo}, status: :ok
            end
        end
        
        def destroy
            todo = Todo.find(params[:id])
            todo.destroy
            render json: {status: 'success', message: 'Todo deleted', data: todo}, status: :ok
        end

        def update
            todo = Todo.find(params[:id])
            if todo.update_attributes(todo_params)
                render json: {status: 'success', message: 'Todo updated', data: todo}, status: :ok
            end
        end
        private

        def todo_params
            params.permit(:user_id, :content, :due_date, :done)
        end
    end
end