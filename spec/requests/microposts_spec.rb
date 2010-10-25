require 'spec_helper'

describe "Microposts" do

  before(:each) do
    @user = Factory(:user)
    visit signin_path
    fill_in :email,    :with => @user.email
    fill_in :password, :with => @user.password
    click_button
  end
  
  describe "creation" do
    
    describe "failure" do
    
      it "should not make a new micropost" do
        lambda do
          visit root_path
          fill_in :micropost_content, :with => ""
          click_button
          response.should render_template('pages/home')
          response.should have_selector("div#error_explanation")
        end.should_not change(Micropost, :count)
      end
    end

    describe "success" do
  
      it "should make a new micropost" do
        content = "Lorem ipsum dolor sit amet"
        lambda do
          visit root_path
          fill_in :micropost_content, :with => content
          click_button
          response.should have_selector("span.content", :content => content)
          response.should have_selector("span", :content => "1 micropost")
        end.should change(Micropost, :count).by(1)
      end
      describe "of multiple microposts" do
        
        before(:each) do
          micropost = Factory(:micropost, :user => @user)
          microposts = [micropost]
          50.times do
            microposts << Factory(:micropost, :user => @user)
          end
          
        end
        
        it "should display the micropost count correctly" do
          visit root_path
          response.should have_selector("span", :content => "51 microposts")
        end
        
        it "should paginate properly" do
          visit root_path
          response.should have_selector("a", :href => "/?page=2")
          response.should have_selector("a", :href => "/microposts/51")
          response.should have_selector("a", :href => "/microposts/22")
          response.should_not have_selector("a", :href => "/microposts/21")
          click_link "Next →"
          response.should have_selector("a", :href => "/?page=1")
          response.should have_selector("a", :href => "/microposts/1")
          response.should have_selector("a", :href => "/microposts/21")
          response.should_not have_selector("a", :href => "/microposts/22")
        end
        
      end
    end
  end
end
