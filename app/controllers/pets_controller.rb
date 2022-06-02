class PetsController < ApplicationController
  def index
    @headers = { "Content-Type" => "application/json", "Authorization" => cookies[:Authorization]}
    @pets = HTTParty.get('http://localhost:3000/pets', headers: @headers)
    #@pets["auth_token"] = cookies[:Authorization]
  end

  def show
    @headers = { 
      "Content-Type" => "application/json",
      "Authorization" => cookies[:Authorization]
    }
    @pet = HTTParty.get('http://localhost:3000/pets/'+ params[:id], headers: @headers)
    @vet_registrations = HTTParty.get('http://localhost:3000/vet_registrations/', headers: @headers)
    @vets = @vet_registrations.select { |vet| vet["pet_id"] == params[:id].to_i } 

    @doctors = HTTParty.get('http://localhost:3000/users/', headers: @headers)
    @appointments = HTTParty.get('http://localhost:3000/appointments', headers: @headers)
  

  end

  def new
    @pet = Pet.new
  end

  def create
    @pet = Pet.new(pet_params)
    @headers = { 
      "Content-Type" => "application/json",
      "Authorization" => cookies[:Authorization]
    }
    @body = {
      name: @pet.name,
      pet_type: @pet.pet_type
    }.to_json
    @response = HTTParty.post('http://localhost:3000/pets',  body: @body, headers: @headers)

    redirect_to root_path
  end

  def edit
    @headers = { 
      "Content-Type" => "application/json",
      "Authorization" => cookies[:Authorization]
    }
    @response = HTTParty.get('http://localhost:3000/pets/'+ params[:id], headers: @headers)

    @pet = Pet.new
    @pet.id = @response['id']
    @pet.name = @response['name']
    @pet.pet_type = @response['pet_type']
    @pet.user_id = @response['user_id']
    @pet.created_at = @response['created_at']
    @pet.updated_at = @response['updated_at']
    
  end

  def update
    @headers = { 
      "Content-Type" => "application/json",
      "Authorization" => cookies[:Authorization]
    }
    @pet_name = params[:pet][:name]
    @pet_type = params[:pet][:pet_type] 
    
    @body = {
      name: @pet_name,
      pet_type: @pet_type
  }.to_json
 
    @response = HTTParty.patch('http://localhost:3000/pets/' + params[:id], body:@body, headers: @headers)
    redirect_to root_path
  end

  def destroy
    @headers = { 
      "Content-Type" => "application/json",
      "Authorization" => cookies[:Authorization]
    }
    @response = HTTParty.delete('http://localhost:3000/pets/' + params[:id], headers: @headers)
 
    redirect_back(fallback_location: root_path)
  end

  private
  def pet_params
    params.require(:pet).permit(:name, :pet_type)
  end

end
