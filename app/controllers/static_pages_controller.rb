class StaticPagesController < ApplicationController
  def index
    @title = "Play all the games!"
  end

  def faq
    @faqs = YAML.load_file("config/faq.yml")
    @title = "Frequently Asked Questions"
  end

  def manage
    @title = "Overview of Site"
  end
end