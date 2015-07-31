FROM stockflare/base

RUN gem build shotgun.gemspec

RUN gem install shotgun-*.gem

ONBUILD ADD ./ /stockflare

ONBUILD RUN bundle install

ENTRYPOINT ["shotgun"]
