require File.dirname(__FILE__) + '/../test_helper'

class GreedyPageTest < Test::Unit::TestCase
  test_helper :page

  def setup
    @root = Factory::setup_page(Factory::make_page!("Root"))
    @root.slug, @root.breadcrumb = "/", "/"
    @root.save!

    title = "A greedy page"
    @page = GreedyPage.find_or_create_by_title(title)
    @page.slug, @page.breadcrumb = title.downcase.tr(' ','-'), title
    @page.status_id = 100
    @page.parts.find_or_create_by_name("body")
    @page.save!
    @root.children << @page
    @root.save!
  end

  # def find_by_url(url, live = true, clean = true)
  def test_that_page_is_found_when_it_normally_would_be_found
    found_page = @root.find_by_url("/a-greedy-page")

    assert_equal @page, found_page
  end

  def test_that_page_is_not_found_when_a_sibling_should_be_found
    sib = Factory::make_kid!(@root, "a-sibling-page")

    found_page = @root.find_by_url("/a-sibling-page")

    assert_equal sib, found_page
  end

  def test_that_page_is_not_found_when_a_child_should_be_found
    kid = Factory::make_kid!(@page, "a-child-page")

    found_page = @root.find_by_url("/a-greedy-page/a-child-page")

    assert_equal kid, found_page
  end

  def test_that_page_is_found_when_a_non_existent_child_is_requested
    found_page = @root.find_by_url("/a-greedy-page/a-child-page")

    assert_equal @page, found_page
  end

  def test_that_url_returns_the_requested_url
    found_page = @root.find_by_url("/a-greedy-page/a-child-page")

    assert_equal "/a-greedy-page/a-child-page/", found_page.url
  end

end
