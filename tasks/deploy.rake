DEV_BRANCH     = 'development'
LOG_RANGE      = "master...#{DEV_BRANCH}"
VERSION_FILE   = 'VERSION'
CHANGELOG_FILE = 'CHANGELOG.md'

desc 'Automated deployment (increment patch)'
task :deploy do
  bump_version('patch')
  deploy
end

namespace 'deploy' do
  desc 'Automated deployment (increment patch)'
  task :patch do
    bump_version('patch')
    deploy
  end
  desc 'Automated deployment (increment minor)'
  task :minor do
    bump_version('minor')
    deploy
  end
  desc 'Automated deployment (increment major)'
  task :major do
    bump_version('major')
    deploy
  end
end

def deploy
  commit_changelog
  merge_changes
  push_release
end

def check_branch
  if ! `git ls-files --others --exclude-standard`.empty?
    abort 'ERROR: There are untracked files!'
  elsif ! system('git diff --quiet && git diff --cached --quiet')
    abort 'ERROR: There are staged but uncommitted files!'
  end
  `git fetch`
end

def bump_version(type = 'patch')
  check_branch
  @version = File.read(VERSION_FILE).strip
  @version.gsub(/(\d+)\.(\d+)\.(\d+)/) {
    @major, @minor, @patch = $1.to_i, $2.to_i, $3.to_i
  }
  case type
  when 'patch'
    @new_version = "#{@major}.#{@minor}.#{@patch + 1}"
  when 'minor'
    @new_version = "#{@major}.#{@minor + 1}.0"
  when 'major'
    @new_version = "#{@major + 1}.0.0"
  end
  File.write('VERSION', @new_version)
end

def changelog
  File.read(CHANGELOG_FILE)
end

def changes
  @changes ||= `git log #{LOG_RANGE} --no-merges`
end

def pretty_changes
  `git log #{LOG_RANGE} --reverse --no-merges --pretty=format:'  * %s ([%cn - %h](https://github.com/vghn/vscripts/commit/%H))'`
end

def update_changelog
  puts 'Writing new changelog'
  File.write(
    CHANGELOG_FILE,
    "Version #{@new_version}\n---\n" + pretty_changes + "\n\n" + changelog
  )
end

def commit_changelog
  if changes.lines.count > 0
    update_changelog
    puts 'Committing version and changelog'
    `git commit -am \"Bump version.\"`
  else
    puts 'No changes committed. Exiting.'
    exit 0
  end
end

def branch
  @branch ||= `git branch`.match(/^\* (\S+)/)[1]
end

def switch_to_branch(name)
  `git checkout #{name}` unless branch == name
end

def merge
  @merge ||= `git merge --no-ff #{DEV_BRANCH} -m \"v#{@new_version}\"`
end

def merge_changes
  switch_to_branch('master')
  puts "Merging \"#{DEV_BRANCH}\" branch"
  abort 'ERROR: Conflicts found; Stopping!' if merge =~ /conflict/i
  switch_to_branch(branch) # Switch back to whatever branch was before
end

def push_release
  puts "Tagging v#{@new_version} release."
  `git tag -a v#{@new_version} -m 'Version #{@new_version}'`
  puts 'Pushing all branches and tags'
  `git push --all --follow-tags`
end

def package_and_push_gem
  puts 'Building gem'
  Rake::Task['build'].invoke
  puts 'Pushing gem to Rubygems'
  `gem push pkg/vscripts-#{@new_version}.gem`
end
