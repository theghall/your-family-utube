module TagsHelper
    
    def set_search_key(key)
        session[:search_tag] = key unless key.empty?
    end
    
    def clear_search_key
        session.delete(:search_tag)
    end
    
    def get_search_key
        session[:search_tag]
    end
    
    def get_search_tag
        return Tag.where(name: get_search_key)
    end
    
    def search_tag?
        session[:search_tag].nil? ? false: true
    end
end
