class AppointmentsController < ApplicationController
  def index
    @headers = { "Content-Type" => "application/json", "Authorization" => cookies[:Authorization]}
    @appointments = HTTParty.get('http://localhost:3000/appointments', headers: @headers)
  end

  def show
    @headers = { 
      "Content-Type" => "application/json",
      "Authorization" => cookies[:Authorization]
    }
    @appointment = HTTParty.get('http://localhost:3000/appointments/'+ params[:id], headers: @headers)
    
  end

  def new
    @headers = { "Content-Type" => "application/json", "Authorization" => cookies[:Authorization]}
    @appointment = Appointment.new
    @appointments = HTTParty.get('http://localhost:3000/appointments', headers: @headers)

    @users = HTTParty.get('http://localhost:3000/appointments', headers: @headers)
    @vets = @users.select { |role| role["role"] == "vet" } 
  end

  def create
    @appointment = Appointment.new(appointment_params)
    @headers = { 
      "Content-Type" => "application/json",
      "Authorization" => cookies[:Authorization]
    }
    @body = {
      vet_id: @appointment.vet_id,
      pet_id: @appointment.pet_id,
      date: @appointment.date
    }.to_json

    @response = HTTParty.post('http://localhost:3000/appointments',  body: @body, headers: @headers)
    

    redirect_to pet_path(@appointment.pet_id)
  end

  def edit
    @headers = { 
      "Content-Type" => "application/json",
      "Authorization" => cookies[:Authorization]
    }
    @response = HTTParty.get('http://localhost:3000/appointments/'+ params[:id], headers: @headers)

    @appointment = Appointment.new
    @appointment.vet_id = @response['vet_id']
    @appointment.pet_id = @response['pet_id']
    @appointment.date = @response['date']
        
  end

  def update
    @headers = { 
      "Content-Type" => "application/json",
      "Authorization" => cookies[:Authorization]
    }
    @vet_id = params[:appointment][:vet_id]
    @pet_id = params[:appointment][:pet_id] 
    @date = params[:appointment][:date]
    
    @body = {
      vet_id: @vet_id,
      pet_id: @pet_id,
      date: @date
  }.to_json
 
    @response = HTTParty.patch('http://localhost:3000/appointments/' + params[:id], body:@body, headers: @headers)
    redirect_to root_path
  end

  def destroy
    @headers = { 
      "Content-Type" => "application/json",
      "Authorization" => cookies[:Authorization]
    }
    @response = HTTParty.delete('http://localhost:3000/appointments/' + params[:id], headers: @headers)
 
    redirect_back(fallback_location: root_path)
  end

  private
  def appointment_params
    params.require(:appointment).permit(:pet_id, :vet_id, :date)
  end

end
