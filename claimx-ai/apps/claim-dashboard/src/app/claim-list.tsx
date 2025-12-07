import React, { useEffect, useState } from 'react';
import api from '../utils/api';

interface Claim {
  id: string;
  incidentType: string;
  incidentDate: string;
  status: string;
  description: string;
  riskScore?: number;
  isFlagged?: boolean;
  aiAnalysis?: string;
}

export const ClaimList = () => {
  const [claims, setClaims] = useState<Claim[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchClaims();
  }, []);

  const fetchClaims = async () => {
    try {
      const response = await api.get('/claims');
      setClaims(response.data);
    } catch (error) {
      console.error('Failed to fetch claims', error);
    } finally {
      setLoading(false);
    }
  };

  if (loading) return <div className="text-center py-4">Loading claims...</div>;

  return (
    <div className="max-w-4xl mx-auto mt-8">
      <h2 className="text-2xl font-bold text-gray-800 mb-4">My Claims History</h2>
      
      {claims.length === 0 ? (
        <div className="bg-white p-6 rounded-lg shadow text-center text-gray-500">
          No claims filed yet.
        </div>
      ) : (
        <div className="space-y-4">
          {claims.map((claim) => (
            <div key={claim.id} className="bg-white p-6 rounded-lg shadow border-l-4 border-blue-500">
              <div className="flex justify-between items-start">
                <div>
                  <h3 className="text-lg font-semibold text-gray-800">{claim.incidentType}</h3>
                  <p className="text-sm text-gray-500">{new Date(claim.incidentDate).toLocaleDateString()}</p>
                  <p className="mt-2 text-gray-600">{claim.description}</p>
                </div>
                
                {/* AI Risk Badge */}
                <div className="text-right">
                  <div className="mb-2">
                    <span className={`px-3 py-1 rounded-full text-xs font-bold uppercase tracking-wide ${
                      claim.status === 'PENDING' ? 'bg-yellow-100 text-yellow-800' : 'bg-green-100 text-green-800'
                    }`}>
                      {claim.status}
                    </span>
                  </div>

                  {claim.riskScore !== undefined && (
                    <div className={`p-3 rounded-lg border ${
                      claim.isFlagged 
                        ? 'bg-red-50 border-red-200' 
                        : 'bg-green-50 border-green-200'
                    }`}>
                      <div className="flex items-center justify-end gap-2">
                        <span className="text-xs text-gray-500 uppercase font-bold">AI Risk Score</span>
                        <span className={`text-xl font-bold ${
                          claim.isFlagged ? 'text-red-600' : 'text-green-600'
                        }`}>
                          {claim.riskScore}/100
                        </span>
                      </div>
                      {claim.aiAnalysis && (
                        <p className="text-xs text-gray-600 mt-1 max-w-xs text-right">
                          {claim.aiAnalysis}
                        </p>
                      )}
                    </div>
                  )}
                </div>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
};
