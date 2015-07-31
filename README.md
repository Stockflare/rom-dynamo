# ROM::Dynamo

[AWS DynamoDB](http://aws.amazon.com/dynamodb/) support for [Ruby Object Mapper](https://github.com/rom-rb/rom).

## Usage

Before calling this gem, you need to setup AWS first. The AWS library is pretty flexible at setting up credentials, so there is no need to subsume this functionality (and potentially limit it). As always, you should use an [IAM Instance Profile](http://docs.aws.amazon.com/sdkforruby/api/Aws/InstanceProfileCredentials.html) when possible.

This gem does not handle the creation or deletion of DynamoDB tables. I recommend that you take a look at the sample [AWS Cloudformation examples](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/sample-templates-services-us-west-2.html#d0e67010) as a way to manage your tables and their indexes.

Setup the Dynamo repository like so:

```
rom = ROM.setup(:dynamo, table: 'my_dynamo_table_name', region: 'us-east-1')
```

## Development

Tests are executed against a dynamodb-local docker container. To run the full suite, you will need to have [docker-compose](https://docs.docker.com/compose/install/) installed. Then simply run:

```
$ docker-compose run rom
```

## License

See `LICENSE` file.
