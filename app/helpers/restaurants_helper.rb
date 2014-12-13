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
          @ip_address = ip.ip_address if ip
        end

        Rails.logger.info "IP Address is #{@ip_address}

       params = { 
            origins: "#{origin_address_gps["formatted_address"]}",
            destinations: "#{destination_address_gps["formatted_address"]}",  
            key: key,
            userIp: @ip_address,
            mode: "driving"
          }

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
          key = ["AIzaSyA0zgbkEn__stJJwtR7f9JDxCYrQZC__QY","AIzaSyAw-ItKGrTc6KTfnXwNa2s9KixqrKHVl1c"].sample
        else
          key = ["AIzaSyA0zgbkEn__stJJwtR7f9JDxCYrQZC__QY","AIzaSyAw-ItKGrTc6KTfnXwNa2s9KixqrKHVl1c"].sample
        end

        uri = URI('https://maps.googleapis.com/maps/api/place/textsearch/json')
          params = { 
              key: key, 
              query: "Places near #{current_user_address}",
              types: "restaurant|food",
              userIp: @ip_address,
              radius: 16093 #10 mile radius
            }
          uri.query = URI.encode_www_form(params)

          res = Net::HTTP.get_response(uri)
          Rails.logger.info "Response from Querying Places: #{res.body}"

          JSON.parse(res.body)["results"]
        end
end
