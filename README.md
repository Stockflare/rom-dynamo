# ROM::Dynamo

[AWS DynamoDB](http://aws.amazon.com/dynamodb/) support for [Ruby Object Mapper](https://github.com/rom-rb/rom).

**Note:** Associations are not currently supported.

## Usage

Before calling this gem, you need to setup AWS first. The AWS library is pretty flexible at setting up credentials, so there is no need to subsume this functionality (and potentially limit it). As always, you should use an [IAM Instance Profile](http://docs.aws.amazon.com/sdkforruby/api/Aws/InstanceProfileCredentials.html) when possible.

This gem does not handle the creation or deletion of DynamoDB tables. I recommend that you take a look at the sample [AWS Cloudformation examples](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/sample-templates-services-us-west-2.html#d0e67010) as a handy way to manage your tables and their indexes.

Setup the Dynamo repository like so:

```
rom = ROM.setup(:dynamo, region: 'us-east-1')
```

DynamoDB enables you to build really flexible and powerful queries. In addition to this and taking into consideration that Amazon are constantly improving the capabilities of the querying syntax, I chose not to wrap the functionality that the API provides in a higher-level of abstraction.

The upside, is that this adapter can provide you with a _full_ query interface, enabling you to build some pretty complex calls quite flexibly; the downside is that you actually need to know how to build these queries.

## Aliasing AWS generated table names

If you're using Cloudformations or migrating from a different system, you may have an auto-generated table name like `my-stack-name-PostDynamoDBTable-17V2MIJAWDJ4F3Q`, aliasing this name is as simple as defining the following in your `Relation` class:

```
class PostRelation < ROM::Relation[Application::ORM]
  register_as :posts
  dataset 'my-stack-name-PostDynamoDBTable-17V2MIJAWDJ4F3Q' # hardcoded magnificence!
end
```

You can then access your relation with a more friendly name, ie. `rom.relation(:posts)`.

## Testing your project with ROM::Dynamo

At some stage, you will need to use [dynamodb-local]() so that you can begin to develop and test your project against a locally running DynamoDB (similar to how I test this adapter). To ease the stubbing of the client initialized inside the [Gateway]() class, you can use the following method:

```
dynamo = Aws::DynamoDB::Client.new(endpoint: 'http://localhost:8000')
ROM::Dynamo.stub!(dynamo)
```

## Development

Tests are executed against a dynamodb-local docker container. To run the full suite, you will need to have [docker-compose](https://docs.docker.com/compose/install/) installed. Then simply run:

```
$ docker-compose run rom
```

## License

See `LICENSE` file.
