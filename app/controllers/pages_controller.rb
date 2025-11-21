class PagesController < ApplicationController
    skip_before_action :authenticate_user!, only: %i[home about]

    def home; end

    def about
        @about_us = [
            {
                title: I18n.t("about_us.mentally_healthy.title"),
                info: I18n.t("about_us.mentally_healthy.info"),
                image: I18n.t("about_us.mentally_healthy.image"),
                color: I18n.t("about_us.mentally_healthy.color")

            },
            {
                title: I18n.t("about_us.animal_socialization.title"),
                info: I18n.t("about_us.animal_socialization.info"),
                image: I18n.t("about_us.animal_socialization.image"),
                color: I18n.t("about_us.animal_socialization.color")
            },
            {
                title: I18n.t("about_us.convenience.title"),
                info: I18n.t("about_us.convenience.info"),
                image: I18n.t("about_us.convenience.image"),
                color: I18n.t("about_us.convenience.color")
            }
        ]
    end


    def profile
        @user = current_user
        @adopts = policy_scope(Adopt)
    end
end
