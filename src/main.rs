use tonic::{transport::Server, Request, Response, Status};

use smart_light::light_server::{Light, LightServer};
use smart_light::{Empty, BoolValue};
use std::sync::{Arc, Mutex};

use rppal::gpio::Gpio;

pub mod smart_light {
    tonic::include_proto!("smartlight"); // The string specified here must match the proto package name
}

#[derive(Debug, Default)]
pub struct MyLight {
    is_on: Arc<Mutex<bool>>
}

#[tonic::async_trait]
impl Light for MyLight {
    async fn is_on(&self, _request: Request<Empty>) -> Result<Response<BoolValue>, Status> {
        let reply = BoolValue {
            value: *Arc::clone(&self.is_on).lock().unwrap()
        };

        Ok(Response::new(reply))
    }

    async fn set_is_on(&self, request: Request<BoolValue>) -> Result<Response<Empty>, Status> {
        let is_on_clone = Arc::clone(&self.is_on);
        let mut is_on = is_on_clone.lock().unwrap();
        let new_value = request.into_inner().value;

        let mut pin = Gpio::new().unwrap().get(18).unwrap().into_output();
        pin.set_reset_on_drop(false);

        if new_value {
            pin.set_high();
        } else {
            pin.set_low();
        }

        *is_on = new_value;
        Ok(Response::new(Empty {}))
    }
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let addr = "0.0.0.0:50051".parse()?;
    let light = MyLight{
        is_on: Arc::new(Mutex::new(false))
    };

    println!("GreeterServer listening on {}", addr);

    Server::builder()
        .add_service(LightServer::new(light))
        .serve(addr)
        .await?;

    Ok(())
}