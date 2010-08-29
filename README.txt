To add jQuery to a Rails3 project simply run
  cp -r install/. /path/to/app/.

Then open your config/application.rb and add
  ActionView::Helpers::AssetTagHelper.register_javascript_expansion :jquery => %w/jquery jquery-ui rails application/

Now when u want jQuery just use
  javascript_include_tag :jquery