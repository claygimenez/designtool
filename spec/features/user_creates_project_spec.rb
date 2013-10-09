require 'spec_helper'

feature 'user creates a project' do
  scenario 'and sees it in the index' do
    create :user
    create :project

    visit projects_path
    expect(page).to have_content('Yuppy')
  end
end
