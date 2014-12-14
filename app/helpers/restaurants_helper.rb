require 'rails'
require 'socket'

module RestaurantsHelper

	def self.calculate_distance_using_google_api(origin_address_gps, destination_address_gps)
       Rails.logger.info "Using Google Maps API to Calculate Distance between #{origin_address_gps["formatted_address"]} and #{destination_address_gps["formatted_address"]}"
       uri = URI('https://maps.googleapis.com/maps/api/distancematrix/json')

        if Rails.env.production?
          key = "AIzaSyDNMJwNQiqU1-0KHZXz6omHpzCaqY5gKCs"
          @ip_address = "54.197.242.176"
        else
          key = "AIzaSyDNMJwNQiqU1-0KHZXz6omHpzCaqY5gKCs"

          ip=Socket.ip_address_list.detect{|intf| intf.ipv4_private?}
          @ip_address = "54.197.242.176"
        end

        Rails.logger.info "IP Address is #{@ip_address}"

       params = { 
            origins: "#{origin_address_gps["formatted_address"]}",
            destinations: "#{destination_address_gps["formatted_address"]}",  
            key: key,
            mode: "driving"
          }

          Rails.logger.info "Parameters from calculate_distance_using_google_api method #{params}"

          uri.query = URI.encode_www_form(params)

         res = Net::HTTP.get_response(uri)
         Rails.logger.info "Response from Google Maps API: #{res.body}"

         distance_from = JSON.parse(res.body)["rows"].first.nil? ? "1000" : JSON.parse(res.body)["rows"].first["elements"].first["distance"]["value"]
         drive_time = JSON.parse(res.body)["rows"].first.nil? ? "1000" : JSON.parse(res.body)["rows"].first["elements"].first["duration"]["value"]

         @distance_result = {
          distance_from_user: distance_from,
          drive_time_for_user: drive_time
        }
         Rails.logger.info "Distance Result: #{@distance_result} Meters | Seconds"
         @distance_result
       end

  def self.query_nearby_places(current_user_address)
    if Rails.env.production?
      key = ["AIzaSyA0zgbkEn__stJJwtR7f9JDxCYrQZC__QY"].sample
    else
      key = ["AIzaSyA0zgbkEn__stJJwtR7f9JDxCYrQZC__QY"].sample
    end

    uri = URI('https://maps.googleapis.com/maps/api/place/textsearch/json')
      params = { 
          key: key, 
          query: "Places near #{current_user_address}",
          types: "restaurant|food",
          radius: 160930 #10 mile radius
        }

      Rails.logger.info "Parameters from query_nearby_places method #{params}"


      uri.query = URI.encode_www_form(params)

      res = Net::HTTP.get_response(uri)
      Rails.logger.info "Response from Querying Places: #{res.body}"

      places = JSON.parse(res.body)["results"]

      #getting the second and third pages
      page2_response = retry_collecting_places(current_user_address)
      page2_response[:results].each {|place| places << place}


      places.each { |place| Rails.logger.info "Place: #{place}";  4.times {Rails.logger.info ""} }

      Rails.logger.info "Places Class_________________________________________ #{places.class}"
      Rails.logger.info "Places Size_________________________________________ #{places.size}"
      places
    end

    def self.retry_collecting_places(current_user_address)

    if Rails.env.production?
      key = ["AIzaSyA0zgbkEn__stJJwtR7f9JDxCYrQZC__QY"].sample
    else
      key = ["AIzaSyA0zgbkEn__stJJwtR7f9JDxCYrQZC__QY"].sample
    end

    uri = URI('https://maps.googleapis.com/maps/api/place/textsearch/json')
    params = {
      key: key,
      query: "Restaurants near #{current_user_address}",
      radius: 160930 #10 mile radius
    }

    Rails.logger.info "Parameters from retry_collecting_places method #{params}"


      uri.query = URI.encode_www_form(params)

      res = Net::HTTP.get_response(uri)
      Rails.logger.info "Response from retry_collecting_places request: #{res.body}"

      {results: JSON.parse(res.body)["results"], next_page_token: JSON.parse(res.body)["next_page_token"]}
  end

  def self.retry_with_preferred_cuisine(current_user_address, current_user_preferred_cuisine)

    if current_user_preferred_cuisine.nil?
      preferred_cuisine = "Pizza"
    else
      preferred_cuisine = current_user_preferred_cuisine
    end

    if Rails.env.production?
      key = ["AIzaSyA0zgbkEn__stJJwtR7f9JDxCYrQZC__QY"].sample
    else
      key = ["AIzaSyA0zgbkEn__stJJwtR7f9JDxCYrQZC__QY"].sample
    end

    uri = URI('https://maps.googleapis.com/maps/api/place/textsearch/json')
    params = {
      key: key,
      query: "#{current_user_preferred_cuisine} near #{current_user_address}",
      types: "restaurant|food",
      radius: 160930 #10 mile radius
    }

    Rails.logger.info "Parameters from retry_collecting_places method #{params}"


      uri.query = URI.encode_www_form(params)

      res = Net::HTTP.get_response(uri)
      Rails.logger.info "Response from retry_collecting_places request: #{res.body}"

      {results: JSON.parse(res.body)["results"], next_page_token: JSON.parse(res.body)["next_page_token"]}
  end

end
