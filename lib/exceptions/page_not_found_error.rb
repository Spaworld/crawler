class PageNotFoundError < StandardError

  def initialize(msg='Page not found')
    super
  end

end
