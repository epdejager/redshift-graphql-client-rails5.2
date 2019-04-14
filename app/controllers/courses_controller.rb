class CoursesController < ApplicationController
  IndexQuery = GitHub::Client.parse <<-'GRAPHQL'
    # All read requests are defined in a "query" operation
    query {
    {
      allCourses{
        ...Views::Courses::Index::Course
      }
    }
  }
  GRAPHQL

  def index
    # Use query helper defined in ApplicationController to execute the query.
    # `query` returns a GraphQL::Client::QueryResult instance with accessors
    # that map to the query structure.
    data = RedshiftGraphqlClientRails::Client.query(IndexQuery, variables: {})

    # Render the app/views/repositories/index.html.erb template with our
    # current User.
    #
    # Using explicit render calls with locals is preferred to implicit render
    # with instance variables.
    render "courses/index", locals: {
      courses: data.allCourses
    }
  end
end