class VetsController < ApplicationController
  def index
    @headers = { "Content-Type" => "application/json", "Authorization" => cookies[:Authorization]}
    @vet_registrations = HTTParty.get('http://localhost:3000/vet_index', headers: @headers)
    @pets = @vet_registrations.select { |pet| pet["vet_id"] == params[:id].to_i }

    @pet_names = HTTParty.get('http://localhost:3000/vet_pets_index', headers: @headers)
    @pet_name = @pet_names.select { |pet| pet["pet_id"] == params[:id].to_i }


    @owner = HTTParty.get('http://localhost:3000/users', headers: @headers)
  end

  def show
    @headers = { 
      "Content-Type" => "application/json",
      "Authorization" => cookies[:Authorization]
    }
    @vet_pet = HTTParty.get('http://localhost:3000/pets/'+ params[:id], headers: @headers)
    @appointments = HTTParty.get('http://localhost:3000/vet_appointments_index', headers: @headers)

  end
end