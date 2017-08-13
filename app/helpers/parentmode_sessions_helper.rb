module ParentmodeSessionsHelper
    def parent_mode?
        !session[:parent_id].nil?
    end
  
    def forget_parent
        session.delete(:parent_id)
    end
end
