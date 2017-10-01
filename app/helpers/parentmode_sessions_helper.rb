module ParentmodeSessionsHelper
    include TagsHelper

    def parent_mode?
      !session[:parent_id].nil?
    end
  
    def forget_parent
      session.delete(:parent_id)
    end

    def exit_parent_mode
      clear_search_key if parent_mode?

      forget_parent
    end
end
