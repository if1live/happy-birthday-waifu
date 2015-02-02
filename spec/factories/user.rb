FactoryGirl.define do
  factory :user, class: User do
    password 'helloworld'
    email 'dummy@gmail.com'
  end

  factory :user_a, class: User do
    password 'helloworld-1'
    email 'dummy-1@gmail.com'
  end
end
