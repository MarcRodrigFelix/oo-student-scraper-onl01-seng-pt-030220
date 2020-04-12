require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = open(index_url)
    studentspage = Nokogiri::HTML(html)

    students = []

    studentspage.css("div.student-card").each do |profile|
      students << hash = 
      {
        :name => profile.css(" a div.card-text-container h4.student-name").text,
        :location => profile.css(" a div.card-text-container p.student-location").text,
        :profile_url => profile.css(" a")[0]['href']
      }
    end
    students
  end


  def self.scrape_profile_page(profile_url)
    # scrape each student profile page to get info about student
    html = open(profile_url)
    profile_page = Nokogiri::HTML(html)

    students_profile = profile_page.css("div.main-wrapper.profile")
    info = {}

    students_profile.each do |student|
      info = {
        :profile_quote => student.css(" div.profile-quote").text,
        :bio => student.css(" div.description-holder p").text
      }
      
      links = student.css(" div.social-icon-container a")

      links.each do |link|
        url = link.attr('href')
        
        if url.include?("twitter")
          info[:twitter] = url
        elsif url.include?("linkedin")
          info[:linkedin] = url
        elsif url.include?("github")
          info[:github] = url
        else
          info[:blog] = url
        end
      end
    end

    info
  end

end

# a = Scraper.scrape_index_page("https://learn-co-curriculum.github.io/student-scraper-test-page/")
# binding.pry
# profile uri = doc.css("div.student-card a[href]").map(&:values)
# name = doc.css("div.student-card a div.card-text-container h4.student-name").map(&:text)
# location = doc.css("div.student-card a div.card-text-container p.student-location").map(&:text)

# profile uri :
  # doc.css("div.student-card a").map{|link| link['href'] }
  # doc.css("div.student-card a[href]").first.values
  # doc.css("div.student-card a")[0]["href"]





    # :twitter => student.css(" div.vitals-container div.social-icon-container a")[0]['href'],
    # :linkedin => student.css(" div.vitals-container div.social-icon-container a")[1]['href'],
    # :github => student.css(" div.vitals-container div.social-icon-container a")[2]['href'],
    # :blog => student.css(" div.vitals-container div.social-icon-container a")[3]['href'],
    # :profile_quote => student.css(" div.vitals-container div.vitals-text-container div.profile-quote").text,
    # :bio => student.css(" div.details-container div.bio-content.content-holder div.description-holder p").text


    # if student.css(" div.vitals-container div.social-icon-container img.social-icon")[0]['href']
    #   info[:twitter] = student.css(" div.vitals-container div.social-icon-container a")[0]['href']
    # elsif student.css(" div.vitals-container div.social-icon-container img.social-icon")[1]['href']
    #   info[:linkedin] = student.css(" div.vitals-container div.social-icon-container a")[1]['href']
    # elsif student.css(" div.vitals-container div.social-icon-container img.social-icon")[2]['href']
    #   info[:github] = student.css(" div.vitals-container div.social-icon-container a")[2]['href']
    # elsif student.css(" div.vitals-container div.social-icon-container img.social-icon")[3]['href']
    #   info[:blog] = student.css(" div.vitals-container div.social-icon-container a")[3]['href']
    # end
    # info[:profile_quote] = student.css(" div.vitals-container div.vitals-text-container div.profile-quote").text
    # info[:bio] = student.css(" div.details-container div.bio-content.content-holder div.description-holder p").text