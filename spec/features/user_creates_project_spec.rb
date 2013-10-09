require 'spec_helper'

feature 'user creates a project', js: true do
  scenario 'and sees it in the index' do
    project = create :project
    visit projects_path

    expect(page).to have_content(project.title)
  end
end
