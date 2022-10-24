using Grpc.Net.Client;
using GrpcService1;

using var channel = GrpcChannel.ForAddress("https://wapp-kmsek4anddkik.azurewebsites.net");
var client = new Greeter.GreeterClient(channel);
var reply = await client.SayHelloAsync(new HelloRequest { Name = "GreeterClient" });

Console.WriteLine("Greeting: " + reply.Message);
Console.WriteLine("Press any key to exit...");
Console.ReadKey();