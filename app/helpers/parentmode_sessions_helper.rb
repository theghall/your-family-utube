module ParentmodeSessionsHelper
    include TagsHelper

    def parent_mode?
      !session[:parent_id].nil?
    end
  
    def curr_manage_mode
      session[:manage_mode]
    end

    def set_manage_mode(mode)
      session[:manage_mode] = mode
    end

    def review_mode?
      session[:manage_mode] == 'review'
    end

    def manage_mode?
      session[:manage_mode] == 'manage'
    end

    def forget_parent
      session.delete(:parent_id)
      session.delete(:manage_mode)
    end

    def exit_parent_mode
      clear_search_key if parent_mode?

      forget_parent
    end
end
