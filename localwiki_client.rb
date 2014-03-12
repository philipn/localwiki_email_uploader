# -*- coding: utf-8 -*-
require 'rest_client'
require 'json'
require 'cgi'
require 'uri'

class LocalWikiClientBase
  
  def initialize args
    @base_url = args[:base_url] or raise ArgumentError, "must need :base_url"
    @api_key = args[:api_key]
  end
  
  def api_path
  end
  
  
  def headers
    _headers = {}
    _authorization_header = authorization_header
    unless _authorization_header.nil?
      _headers[:authorization] = _authorization_header
    end
    _headers[:content_type] = :json
    _headers[:accept] = :json
    return _headers
  end

  def exist?(page_or_id)
    begin
      response = RestClient.get @base_url + api_path + '?slug__icontains=' + URI.escape(page_or_id), headers
      if response.code == 200
        data = JSON.parse(response.to_str)
        if data["count"] == 0
            return nil
        end
        return data["results"][0]
      end
    rescue => e
      puts e
    end
    return nil
  end

  def create(obj)
    raise RuntimeError, "must set api_key" unless can_post?
    puts JSON.dump(obj)
    begin
      response = RestClient.post @base_url + api_path, JSON.dump(obj), headers
      if response.code == 201
        return true
      end
    rescue => e
      puts "Unable create because #{e.message}"
    end
    return false
  end

  def update(page_url, obj)
    raise RuntimeError, "must set api_key" unless can_post?
    puts JSON.dump(obj)
    begin
      response = RestClient.put page_url, JSON.dump(obj), headers
      if response.code == 204
        return true
      end
    rescue => e
      puts "Unable update because #{e.message}"
    end
    return false
  end

  def patch(page_url, obj)
    raise RuntimeError, "must set api_key" unless can_post?
    puts JSON.dump(obj)
    begin
      response = RestClient.patch page_url, JSON.dump(obj), headers
      if response.code == 204
        return true
      end
    rescue => e
      puts "Unable update because #{e.message}"
    end
    return false
  end

  def delete(page_or_id)
    raise RuntimeError, "must set user_name and api_key" unless can_post?
    begin
      response = RestClient.delete @base_url + api_path + CGI.escape(page_or_id), headers
      if response.code == 204
        return true
      end
    rescue => e
      puts "Unable delete because #{e.message}"
    end
    return false
  end

  def search_with_auth(objs)
    raise RuntimeError, "must set user_name and api_key" unless can_post?
    begin
      response = RestClient.get @base_url + api_path + make_query(objs), headers
      if response.code == 200
        return JSON.parse(response.to_str)
      end
    rescue => e
      puts "Can't search because #{e.message}"
    end
    return nil
  end

  def get(path)
    begin
      response = RestClient.get @base_url + path, headers
      if response.code == 200
        return JSON.parse(response.to_str)
      end
    rescue => e
      puts "Can't get because #{e.message}"
    end
    return nil
  end

  private

  def make_query(objs)
    queries = Array.new
    objs.each do |obj|
      queries << "#{obj[0]}__#{obj[1]}=" + CGI.escape(obj[2])
    end
    query = queries.join("&")
    if query
      return "?" + query
    end
    return ""
  end

  def can_post?
    return false if @api_key.blank?
    return true
  end

  def authorization_header
    return nil unless can_post?
    return "Token #{@api_key}"
  end

end

class LocalWikiPage < LocalWikiClientBase

  def api_path
    "/pages/"
  end

end

class LocalWikiFile < LocalWikiClientBase

  def api_path
    "/files/"
  end
  
  def upload(file_path, file_name, slug, region)
    
    begin
      response = RestClient.post @base_url + api_path, {:file => File.new(file_path, 'rb'), :name => file_name, :slug => slug, :region => region}, headers
    rescue => e
      puts e
    end
  end
end

class LocalWikiMap < LocalWikiClientBase
  
  def api_path
    "/maps/"
  end

end
