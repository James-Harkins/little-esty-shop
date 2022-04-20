require './app/services/github_service.rb'

class RepoFacade
  def self.create_repo
    json = Hash.new
    json[:name] = GithubService.get_url('https://api.github.com/repos/enalihai/little-esty-shop')[:name]
    json[:contributers] = GithubService.contributers_with_commits
    Repo.new(json)
  end

  def self.repo_or_error_message
    json = GithubService.get_url('https://api.github.com/repos/enalihai/little-esty-shop')
    json[:message].nil? ? create_repo : json
  end
end