require 'spec_helper'

describe MoviesController do
    describe 'add director' do
      before :each do
        @m=double(Movie, :title => "Star Wars", :director => "director", :id => "1")
        Movie.stub(:find).with("1").and_return(@m)
    end
    it 'should call update attributes and redirect' do
      @m.stub(:update_attributes!).and_return(true)
      put :update, {:id => "1", :movie => @m}
      response.should redirect_to(movie_path(@m))
  end
    it 'should redirect if slected ratings are changed' do
      get :index, {:ratings => {:G => 1}}
      response.should redirect_to(movies_path(:ratings => {:G => 1}))
  end
end


    describe 'edit page for appropriate Movie' do
    it 'When I go to the edit page for the Movie, it should be loaded' do
      mock = mock('Movie')
      Movie.should_receive(:find).with('13').and_return(mock)
      get :edit, {:id => '13'}
      response.should be_success
    end
     it 'And I fill in "Director" with "Ridley Scott", And  I press "Update Movie Info", it should save the director' do
      mock = mock('Movie')
      mock.stub!(:update_attributes!)
      mock.stub!(:title)
      mock.stub!(:director)
      mock.stub!(:director)
      
      mock2 = mock('Movie')
      
      Movie.should_receive(:find).with('13').and_return(mock)
      mock.should_receive(:update_attributes!)
      post :update, {:id => '13', :movie => mock2 }
    end
    it 'should redirect if sort order has been changed' do
      session[:sort] = 'release_date'
      get :index, {:sort => 'title'}
      response.should redirect_to(movies_path(:sort => 'title', :ratings => 'rest'))
    end
  end

describe 'happy path' do
  before :each do
     @m=double(Movie, :title => "Star Wars", :director => "director", :id => "1")
        Movie.stub(:find).with("1").and_return(@m)
      end
      
      it 'should generate routing for Similar Movies' do
        { :post => movie_similar_path(1)}.should route_to(:controller => "movies", :action => "similar", :id => "1")
      end
      it 'should call the model method that finds similar movies' do
        fake_results = [double('Movie'), double('Movie')]
        Movie.should_receive(:similar_directors).with('director').and_return(fake_results)
        get :similar, :id => "1"
      end
      it 'should select the Similar template for rendering and make results available' do
        Movie.stub(:similar_directors).with('director').and_return(@m)
        get :similar, :id => "1"
        response.should render_template('similar')
        assigns(:movies).should == @m
      end
    end
    
describe 'sad path' do
  before :each do
    m=double(Movie, :title => "Star Wars", :director => "director", :id => "1")
    Movie.stub(:find).with("1").and_return(m)
  end
  
  it 'should generate routing for similar Movies' do
    {:post => movie_similar_path(1) }.should route_to(:controller => "movies", :action => "similar", :id => "1")
  end
  it 'should select the index template for rendering and generate a flash' do
    get :similar, :id => "1"
    response.should 
    flash[:notice].should be_blank
  end
end

describe 'create and destroy' do
  it 'should create a new movie' do
    MoviesController.stub(:create).and_return(double('Movie'))
    post :create, {:id => "1"}
  end
  it 'should destroy a movie' do
    m = double(Movie, :id => "10", :title => "yep", :director => nil)
    Movie.stub(:find).with("10").and_return(m)
    m.should_receive(:destroy)
    delete :destroy, {:id => "10"}
  end
end
end