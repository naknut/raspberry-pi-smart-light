use tonic::{transport::Server, Request, Response, Status};

use smart_light::light_server::{Light, LightServer};
use smart_light::{Empty, BoolValue};
use std::sync::{Arc, Mutex};

use rppal::gpio::Gpio;
use rppal::gpio::{OutputPin};

pub mod smart_light {
    tonic::include_proto!("smartlight"); // The string specified here must match the proto package name
}

#[derive(Debug)]
pub struct MyLight {
    pin: Arc<Mutex<OutputPin>>
}

#[tonic::async_trait]
impl Light for MyLight {
    async fn is_on(&self, _request: Request<Empty>) -> Result<Response<BoolValue>, Status> {
        Ok(Response::new(BoolValue { value: Arc::clone(&self.pin).lock().unwrap().is_set_high() }))
    }

    async fn set_is_on(&self, request: Request<BoolValue>) -> Result<Response<Empty>, Status> {
        let pin_clone = Arc::clone(&self.pin);
        let mut pin = pin_clone.lock().unwrap();
        let new_value = request.into_inner().value;

        if new_value {
            pin.set_high();
        } else {
            pin.set_low();
        }

        Ok(Response::new(Empty {}))
    }
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let addr = "0.0.0.0:50051".parse()?;
    let light = MyLight {
        pin: Arc::new(Mutex::new(Gpio::new()?.get(18)?.into_output()))
    };

    println!("GreeterServer listening on {}", addr);

    Server::builder()
        .add_service(LightServer::new(light))
        .serve(addr)
        .await?;

    Ok(())
}