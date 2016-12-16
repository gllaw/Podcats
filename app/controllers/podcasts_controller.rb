require "open-uri"

class PodcastsController < ApplicationController
  before_action :require_login

  #feature_date = Date.commercial(Date.today.year, Date.today.cweek, 5)
  #today_date = Date.today 
  def index

    # Trending - Automated
    raw_trend = Podcast.where("type_id" => 1).last
    today_date = Date.today

    if !raw_trend   
      find_player
      flash[:message1] = "here"
    elsif today_date > raw_trend.feature_date
      find_player
      flash[:message1] = "else"
    end
    @raw_trend = Podcast.where("type_id" => 1).last
    flash[:message2] = "last #{@raw_trend}"
    # Editor's choice
    @ed_choice = Podcast.where("type_id" => 2).last

    # For the random pick
    podcast_pick_id = rand_picker
    @retro_pick = Podcast.find(podcast_pick_id)
    if !@retro_pick.feature_date
      update_feature_field(podcast_pick_id)
    end
  end

  def show
    flash[:message2] = "#{params[:id]}"
    @podcast_all = Podcast.find(params[:id])
  end

  def new
  end

  def create
    p = Podcast.new(show: params[:show], episode: params[:episode], link: params[:link], description: params[:description], genre: params[:genre], type_id: params[:type_id].to_i)
    if p.save
      flash[:success] = "Thank you for your submission!"
      redirect_to "/podcasts/index"
    else
      flash[:errors] = p.errors.full_messages
      redirect_to :back
    end
  end

  private

  def rand_picker                     #random picker
    # What is the last entry in the db?
    check_random = Podcast.where("type_id" => 3).order(:feature_date).last
    feature_date = Date.commercial(Date.today.year, Date.today.cweek, 5) 
    if check_random.feature_date == feature_date
      return check_random[:id]
    else
      generalized = Podcast.where("feature_date" => nil).where( "type_id" => 3).select(:id)
      start = generalized.first
      tail = generalized.last
      return rand(start[:id]..tail[:id])
    end
  end

  def update_feature_field(id)
    feature_date = Date.commercial(Date.today.year, Date.today.cweek, 5)
    Podcast.find(id).update("feature_date": feature_date)
  end

  def find_player
    top_ten = find_trending_pod.split(';')
    use_site = nil
    for i in 1...top_ten.length
      use_site = Podsite.where("name LIKE ?", "%#{top_ten[i]}%").first
      if use_site
        break
      end
    end # End of for 

    # If we did not find any a top from our list of knowns
    # just use the first
    if !use_site
      use_site = Podsite.last
    end

    # Check site types. Determines how
    # we parse using nokogiri
    doc =""
    doc_desc = ""
    doc_link = ""

    if use_site.site_type == 1
      # sound cloud
      doc = Nokogiri::HTML(open("#{use_site.url}")) 
      doc_link = doc.at("meta[property='twitter:player']")["content"]
      doc_desc = doc.at("meta[name='description']")["content"]
    elsif use_site.site_type == 2
      # npr
      doc_raw = Nokogiri::HTML(open("#{use_site.url}")).css("code")[0].text
      doc_desc = Nokogiri::HTML(open("#{use_site.url}")).css(".audio-module-title")[0].text

      # additional data massaging here
      doc_raw_array = doc_raw.split('=')
      doc_link = doc_raw_array[1] # Value after iframe src=
    elsif use_site.site_type == 3
      doc_link = "http://www.radiolab.org/widgets/bucket_player/#slotname=radiolab-bucket-player-episodes"
      doc_desc = "Radiolab, WNYC, NPR, radio, Radio Lab, Podcast, Science, Stories, Story-telling, Documentary, Jad Abumrad, Robert Krulwich"
    else use_site.site_type == 4
      # this american life
      doc_link = Nokogiri::HTML(open("#{use_site.url}")).css(".embed textarea div")[0]["id"]
    
      doc_desc_raw = Nokogiri::HTML(open("#{use_site.url}")).css(".content")[1].text
      doc_desc = doc_desc_raw
    end

     # feature date
     feature_date = Date.commercial(Date.today.year, Date.today.cweek, 5)
     # At this point, the player link + description should be available
     new_trending_pod = Podcast.new(feature_date: feature_date, type_id: 1, show: use_site.name, link: doc_link, description: doc_desc)
     if new_trending_pod.save
       flash[:message] = "This worked!"
     else
       flash[:message] = "Hmmmm #{use_site.name}"
     end
  end

  def find_trending_pod
     doc = Nokogiri::HTML(open("http://www.itunescharts.net/us/charts/podcasts/")).at("ul[class='chart']")
     list  = doc.css("span").text
     return list.gsub(/\d+/, ';')
  end
end
