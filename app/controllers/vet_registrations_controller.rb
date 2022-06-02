class VetRegistrationsController < ApplicationController
  def index
    @headers = { "Content-Type" => "application/json", "Authorization" => cookies[:Authorization]}
    @vet_registrations = HTTParty.get('http://localhost:3000/vet_registrations', headers: @headers)
  end

  def show
    @headers = { 
      "Content-Type" => "application/json",
      "Authorization" => cookies[:Authorization]
    }
    @vet_registration = HTTParty.get('http://localhost:3000/vet_registrations/'+ params[:id], headers: @headers)
  end

  def new
    @headers = { "Content-Type" => "application/json", "Authorization" => cookies[:Authorization]}
    @vet_registration = VetRegistration.new
    @pets = HTTParty.get('http://localhost:3000/pets', headers: @headers)

    @users = HTTParty.get('http://localhost:3000/users', headers: @headers)
    @vets = @users.select { |role| role["role"] == "vet" } 
  end

  def create
    @vet_registration = VetRegistration.new(vet_registration_params)
    @headers = { 
      "Content-Type" => "application/json",
      "Authorization" => cookies[:Authorization]
    }
    @body = {
      vet_id: @vet_registration.vet_id,
      pet_id:  @vet_registration.pet_id
    }.to_json

    @response = HTTParty.post('http://localhost:3000/vet_registrations',  body: @body, headers: @headers)
    

    redirect_to pet_path(@vet_registration.pet_id)
  end

  def edit
    @headers = { 
      "Content-Type" => "application/json",
      "Authorization" => cookies[:Authorization]
    }
    @response = HTTParty.get('http://localhost:3000/vet_registrations/'+ params[:id], headers: @headers)

    @vet_registration = VetRegistration.new
    @vet_registration.vet_id = @response['vet_id']
    @vet_registration.pet_id = @response['pet_id']
        
  end

  def update
    @headers = { 
      "Content-Type" => "application/json",
      "Authorization" => cookies[:Authorization]
    }
    @vet_id = params[:vet_registration][:vet_id]
    @pet_id = params[:vet_registration][:pet_id] 
    
    @body = {
      vet_id: @vet_id,
      pet_id: @pet_id
  }.to_json
 
    @response = HTTParty.patch('http://localhost:3000/vet_registrations/' + params[:id], body:@body, headers: @headers)
    redirect_to root_path
  end

  def destroy
    @headers = { 
      "Content-Type" => "application/json",
      "Authorization" => cookies[:Authorization]
    }
    @response = HTTParty.delete('http://localhost:3000/vet_registrations/' + params[:id], headers: @headers)
 
    redirect_back(fallback_location: root_path)
  end

  private
  def vet_registration_params
    params.require(:vet_registration).permit(:pet_id, :vet_id)
  end
  
end
