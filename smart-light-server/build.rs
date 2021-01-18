fn main() -> Result<(), Box<dyn std::error::Error>> {
    //tonic_build::compile_protos("proto/smartlight.proto")?;
    tonic_build::configure()
        .build_client(false)
        .compile(&["proto/smartlight.proto"], &["proto/"])?;
    Ok(())
}