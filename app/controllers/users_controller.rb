class UsersController < ApplicationController
  def index
    @headers = { 
      "Content-Type" => "application/json",
      "Authorization" => cookies[:Authorization]
    }
    @users = HTTParty.get('http://localhost:3000/users', headers: @headers)
  end

  def show 
  end

  def new
    @user = User.new
  end
 
  def create 
   
    @body = User.new(user_params)
    @headers = { "Content-Type" => "application/json"}
    @body_hash = {
      name: @body.name,
      email: @body.email,
      password: @body.password,
      password_confirmation: @body.password_confirmation,
      role: @body.role

    }.to_json

    @post_user = HTTParty.post('http://localhost:3000/signup', body: @body_hash, headers: @headers)
    cookies[:Authorization] = @post_user["auth_token"]

    @headers = { "Content-Type" => "application/json", "Authorization" => cookies[:Authorization]}
    @users = HTTParty.get('http://localhost:3000/users', headers: @headers)

    if @body.role == "vet"
      @users = HTTParty.get('http://localhost:3000/users', headers: @headers)
      @user = @users.select { |user| user["email"] == @body.email }.first
      redirect_to vet_pets_path(@user["id"])
    else 
      redirect_to root_path
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end


  def login
    @user = User.new  
  end

  def authenticate
    @body = User.new(user_params)
    @headers = { "Content-Type" => "application/json"}
    @body_hash = {
      email: @body.email,
      password: @body.password,
    }.to_json
    
    @login_user = HTTParty.post('http://localhost:3000/auth/login', body: @body_hash, headers: @headers)

    if @login_user.response.body["auth_token"].present?

      cookies[:Authorization] = @login_user["auth_token"]

      @users = HTTParty.get('http://localhost:3000/users', headers: @headers)
      @user = @users.select { |user| user["email"] == @body['email'] }.first
      
      if @user["role"] == "vet"
        redirect_to vet_pets_path(@user["id"]) 
      elsif @user["role"] == "owner"
        redirect_to root_path
      else 
        redirect_to login_path
      end
    end
  end

  def logout
    @headers = { 
      "Content-Type" => "application/json",
      "Authorization" => cookies[:Authorization]
    }

    cookies[:Authorization] = ""
    redirect_to login_path
  end


  private
  def user_params
    params.require(:user).permit(:name, :email, :role, :password, :password_confirmation)
  end

  
end
