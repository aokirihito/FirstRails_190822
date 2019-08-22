Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#quiz'
  get 'index', to: 'welcome#top'
  get 'quiz', to: 'welcome#quiz'
  get 'topic', to: 'welcome#topic'
  get 'import', to: 'welcome#import'
  post 'import', to: 'welcome#import_csv'
  get 'easy', to: 'welcome#quiz'
  get 'medium', to: 'welcome#quiz'
  get 'hard', to: 'welcome#quiz'
  get 'veryhard', to: 'welcome#quiz'
end
