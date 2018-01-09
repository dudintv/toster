class Search < ApplicationRecord
  SEARCH_OBJECTS = %w(Questions Answers Comments Users).freeze
  
  def self.search(search_string, search_object)
    string_with_escape = ThinkingSphinx::Query.escape(search_string)
    if SEARCH_OBJECTS.include?(search_object)
      search_object.singularize.constantize.search(string_with_escape)
    else
      ThinkingSphinx.search(string_with_escape)
    end
  end
end
