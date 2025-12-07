from fastapi import FastAPI
import uvicorn

# Initialize FastAPI app
app = FastAPI(
    title="ClaimX AI Service",
    description="Microservice for Fraud Detection and Image Analysis",
    version="1.0.0"
)

@app.get("/")
def read_root():
    """Root endpoint to verify service is running."""
    return {
        "service": "ClaimX AI Engine",
        "status": "online",
        "version": "1.0.0"
    }

@app.get("/health")
def health_check():
    """Health check endpoint for monitoring."""
    return {"status": "healthy"}

if __name__ == "__main__":
    # Run the server on port 8000
    print("🚀 Starting AI Service on http://localhost:8000")
    uvicorn.run(app, host="0.0.0.0", port=8000)
