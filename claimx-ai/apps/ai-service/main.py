from fastapi import FastAPI
from pydantic import BaseModel
import uvicorn

# Initialize FastAPI app
app = FastAPI(
    title="ClaimX AI Service",
    description="Microservice for Fraud Detection and Image Analysis",
    version="1.0.0"
)

# --- Data Models ---

class ClaimData(BaseModel):
    description: str
    incidentType: str
    amount: float

class FraudAnalysisResult(BaseModel):
    riskScore: int
    isFraud: bool
    reason: str

# --- Logic ---

def analyze_claim_heuristics(data: ClaimData) -> FraudAnalysisResult:
    risk_score = 0
    reasons = []
    
    # Convert description to lowercase for easier matching
    desc = data.description.lower()
    
    # Rule 1: Suspicious Keywords
    keywords = ["no witnesses", "cash", "late at night", "dark", "unknown"]
    for word in keywords:
        if word in desc:
            risk_score += 20
            reasons.append(f"Contains suspicious keyword: '{word}'")
            
    # Rule 2: High Value Claims
    if data.amount > 50000:
        risk_score += 30
        reasons.append("High claim amount (> $50k)")
        
    # Rule 3: Short Description (Vague)
    if len(desc) < 20:
        risk_score += 15
        reasons.append("Description is too vague/short")
        
    # Cap score at 100
    risk_score = min(risk_score, 100)
    
    return FraudAnalysisResult(
        riskScore=risk_score,
        isFraud=risk_score >= 50,
        reason="; ".join(reasons) if reasons else "No immediate red flags detected."
    )

# --- Endpoints ---

@app.post("/analyze", response_model=FraudAnalysisResult)
def analyze_claim(data: ClaimData):
    """Analyze a claim for potential fraud."""
    result = analyze_claim_heuristics(data)
    return result

@app.get("/")
def read_root():
    return {"status": "online", "service": "ClaimX AI Engine"}

@app.get("/health")
def health_check():
    return {"status": "healthy"}

if __name__ == "__main__":
    print("🚀 Starting AI Service on http://localhost:8000")
    uvicorn.run(app, host="0.0.0.0", port=8000)
if __name__ == "__main__":
    # Run the server on port 8000
    print("🚀 Starting AI Service on http://localhost:8000")
    uvicorn.run(app, host="0.0.0.0", port=8000)
