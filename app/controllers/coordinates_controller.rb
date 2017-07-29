require "http"
require 'openssl'
   
class CoordinatesController < ApplicationController
  def new
  	@coordinate = Coordinate.new
  end

  def create
  	@coordinate = Coordinate.new(coordinates_params)
  	if Coordinate.where("address LIKE ?", @coordinate.address).present? #if the address is already present in the db
  		found_coordinate = Coordinate.where("address LIKE ?", @coordinate.address)
  		@coordinate.latitute = found_coordinate[0].latitute
  		@coordinate.longitude = found_coordinate[0].longitude
		respond_to do |format|
      		format.json { render :json => {:coordinates => @coordinate, :success => "true"} }
      	end
  	else 
  		#random function to determine whether the server generates random coordinates or not also checks to see if server_lookup config is true
  		if (rand(0..10)%2 == 0) && (Rails.configuration.server_lookup) 
	  		latitute_offset = rand(0..10)
	  		longitude_offset = rand(0..10)
			@coordinate.latitute = -8.783 + latitute_offset #the values of -.783 and -124.509 are coordinates of pacific ocean
			@coordinate.longitude = -124.509 + longitude_offset
			if(@coordinate.save)
				respond_to do |format|
	      			format.json { render :json => {:coordinates => @coordinate, :success => "true"} }
	      		end
			else
				respond_to do |format|
	      			format.json { render :json => "Error in saving", :status => "400" }
	      		end
			end
		else #server look up fail, now get response from google map api
			request_address = @coordinate.address.gsub(/\s/,'+')
			url = "https://maps.googleapis.com/maps/api/geocode/json?address="+request_address+"CA&key=AIzaSyCOlz5MTd9p8HL9to5E1vJmeE_VixzD3XE"
			response = HTTP.get(url).to_s;
			parsed_response = JSON.parse(response)
			location = parsed_response['results'][0]['geometry']['location']
			#now save it in database
			@coordinate.latitute = location['lat']
			@coordinate.longitude = location['lng']
			@coordinate.save
			
			respond_to do |format|
	      		format.json { render :json => {:coordinates => parsed_response, :success => "false"} }
	      	end
		end
  	end
  end

  private
  	def coordinates_params
      params.require(:coordinate).permit(:address)
  	end
end