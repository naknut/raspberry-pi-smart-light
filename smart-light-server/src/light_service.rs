use std::sync::Mutex;
use rppal::gpio::{Level, OutputPin};
use smart_light::light_server::Light;
use tonic::{Request, Response, Status};
use smart_light::light_server::LightServer;

mod smart_light {
    tonic::include_proto!("smartlight");
}

pub struct Service {
    pin: Mutex<OutputPin>
}

#[tonic::async_trait]
impl Light for Service {
    async fn get_is_on(&self, _request: Request<()>) -> Result<Response<bool>, Status> {
        Ok(Response::new(self.pin.lock().unwrap().is_set_high()))
    }

    async fn set_is_on(&self, request: Request<bool>) -> Result<Response<()>, Status> {
        self.pin.lock().unwrap().write(if request.into_inner() { Level::High } else { Level::Low });
        Ok(Response::new({}))
    }
}

pub fn server(pin: Mutex<OutputPin>) -> LightServer<Service> {
    return LightServer::new(Service { pin: pin });
}