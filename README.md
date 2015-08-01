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

DynamoDB enables you to build really flexible and powerful queries. In addition to this fact and taking into  consideration that Amazon are constantly improving the capabilities of the querying syntax, I chose not to wrap the functionality that the API provides in a higher-level of abstraction.

The upside, is that this adapter can provide you with a _full_ query interface, enabling you to build some pretty complex calls quite simply; the downside is that you actually need to know how to build these queries.

## Development

Tests are executed against a dynamodb-local docker container. To run the full suite, you will need to have [docker-compose](https://docs.docker.com/compose/install/) installed. Then simply run:

```
$ docker-compose run rom
```

## License

See `LICENSE` file.
