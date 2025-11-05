class PagesController < ApplicationController
    def home
    end
    def about
        @about_us = [
    {
        title: "mentally healthy",
        info: "For many people, especially those who are lonely, having a pet can be a valuable source of comfort and company. Renting a pet gives lonely people the opportunity to enjoy the presence and love of a pet, which can significantly increase their mood and well-being at such a difficult time.",
        image: "about_us_1.png",
        color: "#DEC1E9"
        
    },
    {
        title: "animal socialization",
        info: "Many pets need to socialize and interact with people and other animals to be happy and healthy. Renting pets also helps those animals that are looking for a permanent home. While they are on rent, they receive care, attention and the opportunity to show their best qualities to potential adopters. This can significantly increase the chances of their successful adaptation and a happy life in a new home.",
        image: "about_us_2.png",
        color: "#7383D9"
    },
    {
        title: "convenience",
        info: "You choose your own rental period and schedule, convenient for you. All you need is to pick up your pet and enjoy a temporary companion. Renting allows you to enjoy the wonderful world of animals. You can gain valuable experience and understand whether a particular animal species suits you.",
        image: "about_us_3.png",
        color: "#C97E54"
    }
]
      end
    def contact
        @contact_us = ContactUs.new
    end

    def profile
        @user = current_user
        @current_user_adopts = @user.adopts
        @adopts = Adopt.joins(:dog).order("dogs.name ASC")
    end
end
