use tonic::{transport::Server, Request, Response, Status};

use smart_light::light_server::{Light, LightServer};
use smart_light::{Empty, BoolValue};
use std::sync::{Mutex};

use rppal::gpio::Gpio;
use rppal::gpio::{Level, OutputPin};

pub mod smart_light {
    tonic::include_proto!("smartlight");
}

#[derive(Debug)]
pub struct MyLight {
    pin: Mutex<OutputPin>
}

#[tonic::async_trait]
impl Light for MyLight {
    async fn is_on(&self, _request: Request<Empty>) -> Result<Response<BoolValue>, Status> {
        Ok(Response::new(BoolValue { value: self.pin.lock().unwrap().is_set_high() }))
    }

    async fn set_is_on(&self, request: Request<BoolValue>) -> Result<Response<Empty>, Status> {
        self.pin.lock().unwrap().write(if request.into_inner().value { Level::High } else { Level::Low });
        Ok(Response::new(Empty {}))
    }
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let addr = "0.0.0.0:50051".parse()?;

    println!("Listening on {}", addr);
    Server::builder()
        .add_service(LightServer::new(MyLight { pin: Mutex::new(Gpio::new()?.get(18)?.into_output()) }))
        .serve(addr)
        .await?;

    Ok(())
}