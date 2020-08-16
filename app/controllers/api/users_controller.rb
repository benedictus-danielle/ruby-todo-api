module Api
    class UsersController < ApplicationController
        def index
            users = User.order('created_at DESC')
            render json: {status: 'success', message: 'users loaded', data: users}, status: :ok
        end
        
        def show
            user = User.find(params[:id])
            render json: {status: 'success', message: 'user loaded', data: user}, status: :ok
        end

        def create
            body = JSON.parse(request.body.read)
            user = User.new(:username => body["username"], :password => body["password"])
            if user.save
                render json: {status: 'success', message: 'user registered', data: user}, status: :ok
            end
        end
        
        def destroy
            user = User.find(params[:id])
            user.destroy
            render json: {status: 'success', message: 'user deleted', data: user}, status: :ok
        end

        def update
            user = User.find(params[:id])
            if user.update_attributes(user_params)
                render json: {status: 'success', message: 'user updated', data: user}, status: :ok
            end
        end

        def login
            body = JSON.parse(request.body.read)
            user = User.where("username = ? AND password = ?", body["username"], body["password"]).first
            if user == nil
                render json: {data: "Wrong username or password"}
            else
                render json: {data: payload(user)}
            end

        end

        private def user_params
            params.permit(:id, :username, :password, :confirmation_password)
        end

        private def payload(user)
            return nil unless user&.id
            {
                auth_token: JsonWebToken.encode({user_id: user.id, expire: DateTime::current() + 1.days}),
                user: {id: user.id, username: user.username},

            }
        end

        def verify_token
            if request.headers['Authorization'].present?
                token = JsonWebToken.decode(request.headers['Authorization'].split(' ').last)
                if token == nil
                    render json: {errors: ["Not authorized"]}, status: :unauthorized
                    return
                end
                if DateTime.parse(token["expire"]) <= DateTime.current
                    render json: {errors: ["Token expired"]}, status: :not_acceptable
                    return
                end
                render json: {data: true}, status: :ok
            else
                render json: {errors: ["Not authorized"]}, status: :unauthorized
            end
        end
    end
end