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

end