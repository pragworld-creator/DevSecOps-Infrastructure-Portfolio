#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
yum update -y
yum install -y httpd # 2. Install Apache and Update
systemctl start httpd
systemctl enable httpd

# 3. Fetch Metadata
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/instance-id)
AZ=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
PRIVATE_IP=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/local-ipv4)

# 4. Create the Professional 3-Tier Dashboard
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>Aakash Nigam | 3-Tier Architecture</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #0d1117; color: #c9d1d9; margin: 0; padding: 20px; line-height: 1.6; }
        .container { max-width: 1000px; margin: auto; background: #161b22; padding: 40px; border-radius: 12px; border: 1px solid #30363d; box-shadow: 0 12px 48px rgba(0,0,0,0.6); }
        
        /* Header Profile Section */
        .profile-header { display: flex; align-items: center; justify-content: space-between; border-bottom: 2px solid #30363d; padding-bottom: 25px; margin-bottom: 30px; }
        .profile-info h1 { color: #58a6ff; margin: 0; font-size: 2.2em; }
        .profile-info p { color: #8b949e; margin: 5px 0 0 0; font-size: 1.1em; letter-spacing: 0.5px; }
        .experience-tag { background: #238636; color: white; padding: 4px 12px; border-radius: 20px; font-size: 0.85em; font-weight: bold; }

        /* Status & Grid */
        .status-box { background: rgba(88, 166, 255, 0.05); padding: 20px; border-left: 5px solid #58a6ff; margin: 25px 0; border-radius: 4px; }
        .grid { display: grid; grid-template-columns: 1fr 1fr; gap: 25px; }
        .card { background: #21262d; padding: 25px; border-radius: 8px; border: 1px solid #30363d; height: 100%; }
        .card h3 { color: #f0883e; margin-top: 0; display: flex; align-items: center; gap: 10px; }
        
        .highlight { color: #d29922; font-family: 'Courier New', monospace; font-weight: bold; }
        .footer { margin-top: 40px; text-align: center; color: #8b949e; font-size: 0.9em; border-top: 1px solid #30363d; padding-top: 20px; }
        .db-badge { background: #238636; color: white; padding: 3px 10px; border-radius: 12px; font-weight: bold; }
    </style>
</head>
<body>
    <div class="container">
        <!-- Professional Bio Header -->
        <div class="profile-header">
            <div class="profile-info">
                <h1>Aakash Nigam</h1>
                <p>AI Automation Workflow & DevOps Engineer</p>
            </div>
            <div class="experience-tag">3+ Years Experience</div>
        </div>

        <p style="font-size: 1.05em; color: #8b949e;">
            Specializing in <strong>AI Automation Agent Design</strong> and robust <strong>Cloud Infrastructure</strong>. 
            Expert in implementing Linux Identity Access Management (IAM) and Governance, Risk, and Compliance (GRC) frameworks.
        </p>
        
        <!-- Live Infrastructure Monitoring -->
        <div class="status-box">
            <h3 style="color: #58a6ff; margin-top:0;">🌐 Live Traffic Orchestration</h3>
            <p>Your request was processed by an isolated application tier instance:</p>
            <div style="display: flex; gap: 40px; margin-top: 10px;">
                <span>Instance: <span class="highlight">${INSTANCE_ID}</span></span>
                <span>Zone: <span class="highlight">${AZ}</span></span>
                <span>IP: <span class="highlight">${PRIVATE_IP}</span></span>
            </div>
        </div>

        <div class="grid">
            <!-- Project Technical Detail -->
            <div class="card">
                <h3>🛠️ Infrastructure as Code</h3>
                <ul style="padding-left: 20px;">
                    <li><strong>HashiCorp Terraform:</strong> Fully modularized HCL architecture.</li>
                    <li><strong>Backend Management:</strong> Remote S3 state with DynamoDB locking.</li>
                    <li><strong>Scalability:</strong> Auto Scaling Groups across Multi-AZ subnets.</li>
                </ul>
            </div>

            <!-- Compliance & Security -->
            <div class="card">
                <h3>🛡️ GRC & Security Posture</h3>
                <ul style="padding-left: 20px;">
                    <li><strong>Zero-Trust:</strong> Security Group chaining between all 3 tiers.</li>
                    <li><strong>Identity:</strong> IAM Instance Profiles for least-privilege access.</li>
                    <li><strong>Isolation:</strong> RDS & EC2 residing in strictly private subnets.</li>
                </ul>
            </div>
        </div>
        
        <div class="footer">
            <p>Database Connectivity: <span class="db-badge">Active & Secure</span></p>
            <p>Built with Terraform & Amazon Linux 2023 | 2026 Enterprise Deployment</p>
        </div>
    </div>
</body>
</html>
EOF