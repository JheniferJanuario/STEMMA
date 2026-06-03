public class Prontuario
{
    public Guid Id { get; private set; }

    public Guid ConsultaId { get; private set; }

    public string Observacoes { get; private set; }

    public string Diagnostico { get; private set; }

    public string Tratamento { get; private set; }

    public string Medicacao { get; private set; }

    public decimal? Peso { get; private set; }

    public DateTime DataRegistro { get; private set; }

    protected Prontuario() {
        Observacoes = string.Empty;
        Diagnostico = string.Empty;
        Tratamento = string.Empty;
        Medicacao = string.Empty;
    }

    public Prontuario(
        Guid consultaId,
        string observacoes,
        string diagnostico,
        string tratamento,
        string medicacao,
        decimal? peso)
    {
        Validar(
            consultaId,
            observacoes,
            diagnostico);

        Id = Guid.NewGuid();
        ConsultaId = consultaId;
        Observacoes = observacoes;
        Diagnostico = diagnostico;
        Tratamento = tratamento;
        Medicacao = medicacao;
        Peso = peso;
        DataRegistro = DateTime.UtcNow;
    }

    public void Atualizar(
        string observacoes,
        string diagnostico,
        string tratamento,
        string medicacao,
        decimal? peso)
    {
        Validar(
            ConsultaId,
            observacoes,
            diagnostico);

        Observacoes = observacoes;
        Diagnostico = diagnostico;
        Tratamento = tratamento;
        Medicacao = medicacao;
        Peso = peso;
    }

    private void Validar(
        Guid consultaId,
        string observacoes,
        string diagnostico)
    {
        if (consultaId == Guid.Empty)
            throw new ArgumentException("Consulta obrigatória.");

        if (string.IsNullOrWhiteSpace(observacoes))
            throw new ArgumentException("Observações obrigatórias.");

        if (string.IsNullOrWhiteSpace(diagnostico))
            throw new ArgumentException("Diagnóstico obrigatório.");
    }
}