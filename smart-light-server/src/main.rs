use tonic::transport::{Server};
use rppal::gpio::Gpio;
use std::sync::{Mutex};
mod light_service;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let addr = "0.0.0.0:50051".parse()?;
    let pin = Mutex::new(Gpio::new()?.get(18)?.into_output());

    println!("Listening on {}", addr);
    Server::builder()
        .add_service(light_service::server(pin))
        .serve(addr)
        .await?;

    Ok(())
}