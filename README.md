# ScrapCbfRecord

This gem is a complement for the gem [ScrapCbf](https://github.com/pedrogglima/scrap-cbf). It helps saving ScrapCbf data to the database. The ScrapCbf data is made of collections of entities (matches, rankings, rounds and teams). This gem will help encapsulating the logic for saving the entities of each collection.

To accomplish that in a satisfatory way, the gem must offers some flexibity on how and where saves the data. The configuration below helps understand how we accomplish that:

_Note: this gem only works with the ORM Active Record, for right now._

_Note: The following configuration is the default. For Rails, add it to initialize folder._

    # config/initialize/scrap_cbf_record.rb

    ScrapCbfRecord.settings do |config|

      # Important: This gem expects that your app will have define the models to
      # represent the entities Championship, Match, Rank, Round, Team. You may
      # also use indexes to improve searching and secure data consistence.
      # Having that, this gem will offer flexibity to adapt the ScrapCbf data to
      # meet with your models expectations. Said that, to create these models
      # you may read this page to understand how it will work with your app and
      # check the ScrapCbf Readme page to see the data that your models will
      # consist.

      config.match = {
        # Model class representing the entity Match.
        # You may use a different name to represent this entity.
        class_name: 'Match'

        # Rename the attributes for Match.
        # Key must be the old name, the value the new one.
        #  e.g rename_attrs: { id_match: id_played }
        # Check out on the ScrapCbf Readme to see all the attributes.
        rename_attrs: {},

        # Remove an attribute from saving before create the data.
        # You must add the standart attribute name, not the renamed one.
        exclude_attrs_on_create: %i[serie],

        # Remove an attribute from saving before update the data.
        # You must add the standart attribute name, not the renamed one.
        exclude_attrs_on_update: %i[serie],

        # You can create DB associations between entities.
        # There are a limit of possible associations to create.
        # The associations are created from specifics attributes
        #  - e.g attribute team will create foreign_key team_id.
        #    That means attribute team (the name of the team) is a unique
        #    identifier for the entity team. Searching on the entity team by
        #    team's name should returns Team's instance containing
        #    an id, which is used to create the association.
        #
        # You will find here all the possible associations for this entity.
        # In case you don't want associations:
        #  - remove the association from the hash.
        #  - you will still have the attribute corresponding to the
        #    association. You can remove it in exclude_attrs_on_action,
        #    or rename it on rename_attrs.
        #
        # In the future, we may be able to set the associations just
        #  looking on associations definition on the entity class.
        #
        associations: {

          # If you don't want this association, remove the key and value.
          # Association attribute, must not be renamed.
          championship: {
            # The association class name. You may rename this.
            class_name: 'Championship',

            # The foreign_key name for the association. You may rename this.
            foreign_key: :championship_id
          },

          # If you don't want this association, remove the key and value.
          # Association attribute, must not be renamed.
          round: {
            class_name: 'Round',
            foreign_key: :round_id
          },

          # If you don't want this association, remove the key and value.
          # Association attribute, must not be renamed.
          team: {
            class_name: 'Team',
            foreign_key: :team_id
          },

          # If you don't want this association, remove the key and value.
          # Association attribute, must not be renamed.
          opponent: {
            class_name: 'Team',
            foreign_key: :opponent_id
          }
        }
      }

      config.championship = {
        class_name: 'Championship',
        rename_attrs: {},
        exclude_attrs_on_create: %i[],
        exclude_attrs_on_update: %i[],
        associations: {}
       }

      config.ranking = {
        class_name: 'Ranking',
        rename_attrs: {},
        exclude_attrs_on_create: %i[serie],
        exclude_attrs_on_update: %i[serie],
        associations: {
            championship: {
            class_name: 'Championship',
            foreign_key: :championship_id
            },
            team: {
            class_name: 'Team',
            foreign_key: :team_id
            },
            next_opponent: {
            class_name: 'Team',
            foreign_key: :next_opponent_id
            }
        }
      }

      config.round = {
        class_name: 'Round',
        rename_attrs: {},
        exclude_attrs_on_create: %i[serie],
        exclude_attrs_on_update: %i[serie],
        associations: {
            championship: {
            class_name: 'Championship',
            foreign_key: :championship_id
            }
        }
      }

      config.team = {
        class_name: 'Team',
        rename_attrs: {},
        exclude_attrs_on_create: %i[],
        exclude_attrs_on_update: %i[],
        associations: {}
      }

      # If you are not using Rails, define the path where the log will be save
      log_path = Rails.root.join('log', 'scrap_cbf_record.log')
      # Logger is defined by ActiveSupport and load by the ScrapCbfRecord gem
      config.logger = Logger.new(log_path)
    end

## A few more notes about associations

To be able to work with associations, this gem has to make some assumptions.
One of the assumptions is that we are saving the collection of entities Match, Rank and Round associated with Championship. We need that otherwise would be impossible to distinguish matches, ranks and rounds from one year to another. The entity Team doesn't have association with Championship, because a Team exist without a Championship.

What if I don't want my entities Match, Rank and Round having a database association with Championship?. Well, a Championship is unique by the attributes year and serie: each year we have a new Championship, and each Championship has series (we only work with Serie A and B, here). So, if you remove the association Championship from Match, Rank or Round, you would still have to save the year and serie on these entities to make them unique. To summarize with an example:

    # How the gem will search for Match on database when
    # Note: It happens the same for Rank and Round.

    # it has association with Championship
    match = Match.find_by(id_match: id_match, championship_id: championship_id)

    # it hasn't association with Championship
    match = Match.find_by(id_match: id_match, championship: year, serie: serie)

Now you know that if Match, Rank or Round entities have association with Championship, the attribute serie can be removed (on the default config it is removed), but if you decide not to have this association you must not remove the attribute serie.

And how about the others associations? Still with Match, if we decide we don't want association with Round and Team, but want for Championship and Opponent, we would have a table with the following rows:

    Match:
      - championship_id: <ID>
      - round: <round_number>
      - team: <team_name>
      - opponent_id: <ID>
      - other attributes...

As you can see above, Championship and Opponent are foreign keys, Team and Round are integer and string.

For last, this gem has the following assuptions for entities uniqueness:

- Championship: attributes year and serie.
- Match: attributes id_match, championship_id or year and serie.
- Rank: attributes position, championship_id or year and serie.
- Round: attributes number, championship_id or year and serie.
- Team: attribute name.

That means these columns will probably have indexes with uniqueness.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'scrap_cbf_record'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install scrap_cbf_record

## Usage

Before saving the data, you may want to check if your configuration file (the one cited above) is agreeing with your database and models. To do that you can excute the following command:

    ScrapCbfRecord::Config.instance.validate!

The command above will check if you create the needed classes and attributes. If one of these were not defined, a exception will be raised indicating which class or attribute was not defined.

_Note: I had this command to run after the configuration block was execute - that way the command above would be execute automatically after setting the configuration, set on Rails config/initialize folder. But I had problem with ActiveStorage module not been load in time for the class, which would raise a method missing exception for has_one_attached/have_many_attached._

Suggestion: create a rake task to run this command. You will need to run it only one time for every change you made on configuration. The rake would look like:

    namespace :scrap_cbf do
      namespace :config do
        task validate!: :environment do
          ScrapCbfRecord::Config.instance.validate!
        end
      end
    end

Now that you test you configuration file, you may save the output from ScrapCbf on database in the following way:

    # output from ScrapCbf
    cbf = ScrapCbf.new(year: 2020)

    # #save accepts #to_h or #to_json
    ScrapCbfRecord::ActiveRecord.save(cbf.to_h)

If everything works right, no info will be displayed. If an active record error occurs while saving a entity, a exception will be raised and the error will be logged. The log will be find on the path defined on your configuration file. If none was passed, the STDOUT will be used.

The log should look like:

    [2021-04-05 16:35:26 +0000] Errors found while saving
    [info] #<Team id: nil, name: nil, state: "state", avatar_url: "avatar_url", created_at: nil, updated_at: nil>
    [error] name: can't be blank

_Note: Each collection of entities are wrapped in a Database Transaction. That means that a collection of entity will not be save if a error is found while saving, but the collections that run before will._

_Note: Because of the association dependency between entities, the following order for saving is apply: Teams, Rankings, Rounds and, for last, Matches._

## Development

This gem requires docker and docker-compose to run tests. The reason is because the tests require a database, which makes easier if we have docker and a database image, instead of installing database dependecies on system.

To run the tests

    # keep the database instance running on background
    docker-compose -d database

    # then execute the command to run the tests
    # you can specify a file adding SPEC=spec/path/to/file to the command
    docker-compose run --rm spec

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pedrogglima/scrap_cbf_record. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ScrapCbfRecord project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/pedrogglima/scrap_cbf_record/blob/master/CODE_OF_CONDUCT.md).
